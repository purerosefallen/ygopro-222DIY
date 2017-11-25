--感情丰富的无表情
function c1156003.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,4,4,c1156003.lcheck)
--  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1156003,4))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c1156003.tg1)
	e1:SetOperation(c1156003.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c1156003.tg2)
	e2:SetOperation(c1156003.op2)
	c:RegisterEffect(e2)
--
end
--
function c1156003.lcheck(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
--
function c1156003.tfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1156003.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c1156003.tfilter1_1(chkc) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c1156003.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c1156003.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
--
function c1156003.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local token=Duel.CreateToken(tp,1156004)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		token:CancelToGrave()
		local e1_1=Effect.CreateEffect(token)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_CHANGE_TYPE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetValue(TYPE_EQUIP+TYPE_SPELL)
		e1_1:SetReset(RESET_EVENT+0x1fc0000)
		token:RegisterEffect(e1_1,true)
		local e1_2=Effect.CreateEffect(token)
		e1_2:SetType(EFFECT_TYPE_SINGLE)
		e1_2:SetCode(EFFECT_EQUIP_LIMIT)
		e1_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_2:SetValue(1)
		token:RegisterEffect(e1_2,true)
		token:CancelToGrave()
		if Duel.Equip(tp,token,tc,false) then
			local sel=Duel.SelectOption(tp,aux.Stringid(1156003,0),aux.Stringid(1156003,1),aux.Stringid(1156003,2),aux.Stringid(1156003,3))
			if sel==0 then
				local e1_3=Effect.CreateEffect(c)
				e1_3:SetDescription(aux.Stringid(1156003,0))
				e1_3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1_3:SetType(EFFECT_TYPE_EQUIP)
				e1_3:SetCode(EFFECT_IMMUNE_EFFECT)
				e1_3:SetValue(c1156003.efilter1_3)
				token:RegisterEffect(e1_3,true)
			end
			if sel==1 then
				local e1_4=Effect.CreateEffect(c)
				e1_4:SetDescription(aux.Stringid(1156003,1))
				e1_4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1_4:SetType(EFFECT_TYPE_EQUIP)
				e1_4:SetCode(EFFECT_UPDATE_ATTACK)
				e1_4:SetValue(1000)
				token:RegisterEffect(e1_4,true)
				local e1_5=Effect.CreateEffect(c)
				e1_5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
				e1_5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
				e1_5:SetRange(LOCATION_SZONE)
				e1_5:SetCondition(c1156003.con1_5)
				e1_5:SetOperation(c1156003.op1_5)
				token:RegisterEffect(e1_5,true)
			end
			if sel==2 then
				local e1_6=Effect.CreateEffect(c)
				e1_6:SetDescription(aux.Stringid(1156003,2))
				e1_6:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1_6:SetType(EFFECT_TYPE_EQUIP)
				e1_6:SetCode(EFFECT_SET_ATTACK)
				e1_6:SetValue(0)
				token:RegisterEffect(e1_6,true)
				local e1_7=Effect.CreateEffect(c)
				e1_7:SetType(EFFECT_TYPE_EQUIP)
				e1_7:SetCode(EFFECT_CANNOT_TRIGGER)
				token:RegisterEffect(e1_7,true)
			end
			if sel==3 then
				local e1_8=Effect.CreateEffect(c)
				e1_8:SetDescription(aux.Stringid(1156003,3))
				e1_8:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1_8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1_8:SetCode(EVENT_BATTLE_DESTROYING)
				e1_8:SetRange(LOCATION_SZONE)
				e1_8:SetTarget(c1156003.tg1_8)
				e1_8:SetOperation(c1156003.op1_8)
				token:RegisterEffect(e1_8,true)
			end
		else
			Duel.SendtoGrave(token,REASON_RULE)
		end
	end
end
--
function c1156003.efilter1_3(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
--
function c1156003.con1_5(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local i=0
	while tc do
		if tc==e:GetHandler():GetEquipTarget() then
			i=1
		end
		tc=eg:GetNext()
	end
	return i==1
end
function c1156003.op1_5(e,tp,eg,ep,ev,re,r,rp)
	local num=ev/2+ev
	Duel.ChangeBattleDamage(ep,num)
end
--
function c1156003.tg1_8(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and eg:IsContains(ec)
end
function c1156003.op1_8(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1156004)
	Duel.Draw(tp,2,REASON_EFFECT)
end
--
function c1156003.tfilter2(c)
	return c:IsCode(1156004) and c:IsFaceup()
end
function c1156003.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1156003.tfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
--
function c1156003.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1156003.tfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e2_1=Effect.CreateEffect(e:GetHandler())
				e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e2_1:SetType(EFFECT_TYPE_SINGLE)
				e2_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e2_1:SetValue(1)
				e2_1:SetReset(RESET_EVENT+0x1fe0000)
				e:GetHandler():RegisterEffect(e2_1,true)
			end
		end
	end
end
--
