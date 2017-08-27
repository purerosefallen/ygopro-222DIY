--辛劳阎魔-乌莉丝
function c2117002.initial_effect(c)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2117002,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,2117002)
	e2:SetCost(c2117002.cost)
	e2:SetTarget(c2117002.destg)
	e2:SetOperation(c2117002.desop)
	c:RegisterEffect(e2)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2117002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,2117002)
	e2:SetCondition(c2117002.spcon)
	e2:SetCost(c2117002.cost)
	e2:SetTarget(c2117002.sptg)
	e2:SetOperation(c2117002.spop)
	c:RegisterEffect(e2)
end
function c2117002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c2117002.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21c)
end
function c2117002.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c2117002.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c2117002.cfilter,tp,LOCATION_MZONE,0,c)
		local dt=Duel.GetMatchingGroupCount(c2117002.filter,tp,0,LOCATION_ONFIELD,nil)
		e:SetLabel(ct)
		return dt>=ct
	end
	local g=Duel.GetMatchingGroup(c2117002.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,e:GetLabel(),0,0)
end
function c2117002.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(c2117002.cfilter,tp,LOCATION_MZONE,0,c)
	local g=Duel.GetMatchingGroup(c2117002.filter,tp,0,LOCATION_ONFIELD,nil)
	if ct>g:GetCount() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,ct,ct,nil)
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c2117002.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x21c) and not c:IsCode(2117002)
end
function c2117002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and Duel.IsExistingMatchingCard(c2117002.ctfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c2117002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c2117002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end