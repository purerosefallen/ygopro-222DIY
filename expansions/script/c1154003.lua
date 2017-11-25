--Trick or treat
function c1154003.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c1154003.lfilter),2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1154003,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1152003)
	e1:SetTarget(c1154003.tg1)
	e1:SetOperation(c1154003.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1)
	e2:SetCondition(c1154003.con2)
	e2:SetOperation(c1154003.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetValue(RACE_FIEND)
	e3:SetCondition(c1154003.con3)
	c:RegisterEffect(e3)
--
end
--
function c1154003.lfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_DARK)
end
--
function c1154003.tfilter1(c)
	return c:IsAbleToHand()
end
function c1154003.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c1154003.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c1154003.tfilter1,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1154003,1))
	local g=Duel.SelectTarget(tp,c1154003.tfilter1,tp,0,LOCATION_GRAVE,1,1,nil)
end
--
function c1154003.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_GRAVE) then
		if Duel.SelectYesNo(1-tp,aux.Stringid(1154003,2)) then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,1151991,0,0x4011,200,200,1,RACE_FIEND,ATTRIBUTE_DARK) then
				local token=Duel.CreateToken(tp,1151991)
				Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
				local e1_1=Effect.CreateEffect(e:GetHandler())
				e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1_1:SetType(EFFECT_TYPE_SINGLE)
				e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1_1:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1_1,true)
				local e1_2=Effect.CreateEffect(e:GetHandler())
				e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1_2:SetType(EFFECT_TYPE_SINGLE)
				e1_2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				e1_2:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1_2,true)
				local e1_3=Effect.CreateEffect(e:GetHandler())
				e1_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+		EFFECT_FLAG_UNCOPYABLE)
				e1_3:SetType(EFFECT_TYPE_SINGLE)
				e1_3:SetCode(EFFECT_DISABLE)
				e1_3:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1_3,true)
				local e1_4=Effect.CreateEffect(e:GetHandler())
				e1_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1_4:SetType(EFFECT_TYPE_SINGLE)
				e1_4:SetCode(EFFECT_CANNOT_ATTACK)
				e1_4:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1_4,true)
				local e1_5=Effect.CreateEffect(e:GetHandler())
				e1_5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1_5:SetType(EFFECT_TYPE_SINGLE)
				e1_5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				e1_5:SetValue(1)
				e1_5:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1_5,true)   
				local e1_6=Effect.CreateEffect(e:GetHandler())
				e1_6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1_6:SetType(EFFECT_TYPE_SINGLE)
				e1_6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				e1_6:SetValue(1)
				e1_6:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1_6,true)
				local e1_7=Effect.CreateEffect(e:GetHandler())
				e1_7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1_7:SetType(EFFECT_TYPE_SINGLE)
				e1_7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				e1_7:SetValue(1)
				e1_7:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1_7,true) 
				local e1_8=Effect.CreateEffect(e:GetHandler())
				e1_8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1_8:SetType(EFFECT_TYPE_SINGLE)
				e1_8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e1_8:SetValue(1)
				e1_8:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1_8,true) 
				local e1_9=Effect.CreateEffect(e:GetHandler())
				e1_9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1_9:SetType(EFFECT_TYPE_SINGLE)
				e1_9:SetCode(EFFECT_DISABLE_EFFECT)
				e1_9:SetReset(RESET_EVENT+0x1fe0000)
				token:RegisterEffect(e1_9,true) 
				local e1_10=Effect.CreateEffect(e:GetHandler())
				e1_10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1_10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1_10:SetRange(LOCATION_MZONE)
				e1_10:SetCode(EVENT_PHASE+PHASE_END)
				e1_10:SetCountLimit(1)
				e1_10:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
				e1_10:SetCondition(c1154003.con1_10)
				e1_10:SetOperation(c1154003.op1_10)
				e1_10:SetLabel(0)
				token:RegisterEffect(e1_10)	   
			end
		end
	end
end
function c1154003.con1_10(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1154003.op1_10(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	else e:SetLabel(1) end
end
--
function c1154003.cfilter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_FIEND)
end
function c1154003.con2(e,c,og)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c1154003.cfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) and c:IsFaceup() and not c:IsDisabled() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--
function c1154003.op2(e,tp,eg,ep,ev,re,r,rp,c,sg,og)  
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1154003.cfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	e:GetHandler():RegisterFlagEffect(1154003,0,RESET_EVENT+0x1fe0000,0)
	sg:Merge(g)
end
--
function c1154003.con3(e)
	return e:GetHandler():GetFlagEffect(1154003)==0
end
--
