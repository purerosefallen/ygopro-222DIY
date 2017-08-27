--新的正义！ 
function c80050024.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCondition(c80050024.sccon)
	e1:SetCost(c80050024.cost)
	e1:SetTarget(c80050024.target)
	e1:SetOperation(c80050024.activate)
	c:RegisterEffect(e1)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetOperation(c80050024.activate1)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(80050024,ACTIVITY_SPSUMMON,c80050024.counterfilter)
end
function c80050024.counterfilter(c)
	return c:IsSetCard(0x32d4)
end
function c80050024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c80050024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(80050024,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c80050024.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c80050024.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x32d4)
end
function c80050024.cfilter(c)
	return not c:IsSetCard(0x32d4)
end
function c80050024.sccon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c80050024.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c80050024.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and c:IsSetCard(0x32d4)
end
function c80050024.filter(c,e,tp)
	return c:IsSetCard(0x32d4) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c80050024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80050024.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c80050024.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c80050024.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80050024.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c80050024.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
		   Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function c80050024.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80050024.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c80050024.activate1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTarget(c80050024.rmtarget)
	e1:SetTargetRange(0xff, 0xff)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c80050024.rmtarget(e,c)
	return not c:IsLocation(0x80)
end