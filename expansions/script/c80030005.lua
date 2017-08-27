--N.三日月 宗近
function c80030005.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0) 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c80030005.efilter)
	c:RegisterEffect(e1)   
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c80030005.splimcon)
	e2:SetTarget(c80030005.splimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e6)
	--special summon rule
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_SPSUMMON_PROC)
	e7:SetRange(LOCATION_HAND)
	e7:SetCondition(c80030005.spcon)
	e7:SetOperation(c80030005.spop)
	c:RegisterEffect(e7)
	--attack twice
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e8:SetValue(2)
	c:RegisterEffect(e8)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80030005,1))
	e5:SetCategory(CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCountLimit(3,80030005)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c80030005.tdcon)
	e5:SetTarget(c80030005.tdtg)
	e5:SetOperation(c80030005.tdop)
	c:RegisterEffect(e5)
	--cannot attack
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetTarget(c80030005.atktarget)
	c:RegisterEffect(e9)
end
function c80030005.atktarget(e,c)
	return not c:IsSetCard(0x92d4)
end
function c80030005.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c80030005.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c80030005.splimit(e,c)
	return not c:IsSetCard(0x92d4)
end
function c80030005.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x92d4)
end
function c80030005.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c80030005.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	return g:GetCount()>=3 and ft>-3 and g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)>-ft
end
function c80030005.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	local g=Duel.GetMatchingGroup(c80030005.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	local sg=nil
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		sg=g:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<3 then
			g:Sub(sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg1=g:Select(tp,3-ct,3-ct,nil)
			sg:Merge(sg1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		sg=g:Select(tp,3,3,nil)
	end
	Duel.SendtoGrave(sg,REASON_COST)
end
function c80030005.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function c80030005.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c80030005.tdop(e,tp,eg,ep,ev,re,r,rp)
		local sg=nil
		local hg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
		local b1=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,1,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
		local b3=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil)
		local op=0
		if not b1 and not b2 and not b3 then return end
		if b1 then
			if b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(80030005,3),aux.Stringid(80030005,4),aux.Stringid(80030005,5))
			elseif b2 and not b3 then
				op=Duel.SelectOption(tp,aux.Stringid(80030005,3),aux.Stringid(80030005,4))
			elseif not b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(80030005,3),aux.Stringid(80030005,5))
				if op==1 then op=2 end
			else
				op=0
			end
		else
			if b2 and b3 then
				op=Duel.SelectOption(tp,aux.Stringid(80030005,4),aux.Stringid(80030005,5))+1
			elseif b2 and not b3 then
				op=1
			else
				op=2
			end
		end
		if op==0 then
			sg=hg:RandomSelect(tp,1)
		elseif op==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(sg)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
			Duel.HintSelection(sg)
		end
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end