--界限龙神 卡奥斯
function c10103010.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c10103010.sprcon)
	e2:SetOperation(c10103010.sprop)
	c:RegisterEffect(e2)  
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c10103010.indval)
	c:RegisterEffect(e3)   
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10103010,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c10103010.spcost)
	e4:SetTarget(c10103010.sptg)
	e4:SetOperation(c10103010.spop)
	c:RegisterEffect(e4)
end
function c10103010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10103010.spfilter(c,e,tp)
	return not c:IsCode(10103010) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsSetCard(0x337)
end
function c10103010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c10103010.spfilter,tp,0x53,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x53)
end
function c10103010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10103010.spfilter,tp,0x53,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 then
		--immue
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c10103010.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		g:GetFirst():RegisterEffect(e1)
	end
end
function c10103010.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c10103010.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c10103010.sprfilter(c)
	return c:IsSetCard(0x1337) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c10103010.sprcon(e,c)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(c10103010.sprfilter,c:GetControler(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:GetCount()>0 and g:GetClassCount(Card.GetCode)>=4
end
function c10103010.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(c10103010.sprfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local g=Group.CreateGroup()
	local tc=nil
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		tc=g1:Select(tp,1,1,nil):GetFirst()
		g:AddCard(tc)
		g1:Remove(Card.IsCode,nil,tc:GetCode())
	end
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end