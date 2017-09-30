--光与暗的自由面
function c10116004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(10116004,2))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10116004+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(c10116004.condition)
	e1:SetTarget(c10116004.target)
	e1:SetOperation(c10116004.activate)
	c:RegisterEffect(e1)
end
function c10116004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c10116004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) and Duel.GetFlagEffect(tp,10116004)<=0
end
function c10116004.thfilter(c)
	return c:IsSetCard(0x3331) and c:IsAbleToHand()
end
function c10116004.spfilter(c,e,tp)
	return c:IsSetCard(0x3331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10116004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c10116004.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c10116004.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(10116004,0),aux.Stringid(10116004,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(10116004,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(10116004,1))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
	e:SetLabel(op)
end
function c10116004.activate(e,tp,eg,ep,ev,re,r,rp)
	local op,g=e:GetLabel()
	if op==0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   g=Duel.SelectMatchingCard(tp,c10116004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	   if g:GetCount()>0 then
		  Duel.SendtoHand(g,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,g)
	   end
	else
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   g=Duel.SelectMatchingCard(tp,c10116004.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	   if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.SelectYesNo(tp,aux.Stringid(10116004,3)) then
		  Duel.BreakEffect()
		  local tc=g:GetFirst()
		  local fid=tc:GetFieldID()
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_FIELD)
		  e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		  e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		  e1:SetTargetRange(1,1)
		  e1:SetReset(RESET_PHASE+PHASE_END)
		  e1:SetLabel(fid)
		  e1:SetLabelObject(tc)
		  e1:SetTarget(c10116004.actg)
		  e1:SetValue(c10116004.aclimit)
		  Duel.RegisterEffect(e1,tp)
		  tc:RegisterFlagEffect(10116004,RESET_EVENT+0x1fe0000,0,1,fid)
	   end
	end
end
function c10116004.actg(e,c)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(10116004)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c10116004.aclimit(e,re,tp)
	return re:GetCode()==EVENT_SPSUMMON_SUCCESS and not re:GetHandler():IsImmuneToEffect(e)
end