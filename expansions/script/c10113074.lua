--超维女王
function c10113074.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c10113074.discon)
	e1:SetOperation(c10113074.disop)
	c:RegisterEffect(e1)   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c10113074.discon2)
	e2:SetOperation(c10113074.disop2)
	c:RegisterEffect(e2)
	--mat check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c10113074.valcheck)
	c:RegisterEffect(e3)
end
function c10113074.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetFlagEffect(10113074)>0
end
function c10113074.valcheck(e,c)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	while tc do
		if tc:IsCode(10113076) then 
		   local e1=Effect.CreateEffect(c)
		   e1:SetDescription(aux.Stringid(10113074,0))
		   e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
		   e1:SetType(EFFECT_TYPE_IGNITION)
		   e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		   e1:SetRange(LOCATION_MZONE)
		   e1:SetCountLimit(1)
		   e1:SetTarget(c10113074.destg)
		   e1:SetOperation(c10113074.desop)
		   e1:SetReset(RESET_EVENT+0xfe0000)
		   c:RegisterEffect(e1)
		   local e2=Effect.CreateEffect(c)
		   e2:SetType(EFFECT_TYPE_SINGLE)
		   e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		   e2:SetValue(1)
		   e2:SetReset(RESET_EVENT+0xfe0000)
		   c:RegisterEffect(e2)
		break end
	tc=g:GetNext()
	end
end
function c10113074.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c10113074.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(200)
		c:RegisterEffect(e1)
	end
end
function c10113074.discon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re and re:GetOwner()==e:GetHandler() and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_MZONE)
end
function c10113074.disop2(e,tp,eg,ep,ev,re,r,rp)
	local g,c=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_MZONE),e:GetHandler()
	local tc=g:GetFirst()
	while tc do
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e1)
	   local e2=e1:Clone()
	   e2:SetCode(EFFECT_DISABLE_EFFECT)
	   tc:RegisterEffect(e2)
	   local e3=e1:Clone()
	   e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	   tc:RegisterEffect(e3)
	tc=g:GetNext()
	end
end
function c10113074.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c10113074.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	bc:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	bc:RegisterEffect(e3)
end