--口袋妖怪 钥圈儿
function c80000149.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--scale
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_LSCALE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c80000149.sccon)
	e6:SetValue(4)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e7) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,80000149)
	e2:SetCondition(c80000149.pcon)
	e2:SetTarget(c80000149.ptg)
	e2:SetOperation(c80000149.pop)
	c:RegisterEffect(e2) 
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(c80000149.splimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	--change battle target
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCode(EVENT_BE_BATTLE_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,80000149)
	e8:SetCondition(c80000149.cbcon)
	e8:SetTarget(c80000149.cbtg)
	e8:SetOperation(c80000149.cbop)
	c:RegisterEffect(e8)
	--change effect target
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCode(EVENT_CHAINING)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,80000149)
	e9:SetCondition(c80000149.cecon)
	e9:SetTarget(c80000149.cetg)
	e9:SetOperation(c80000149.ceop)
	c:RegisterEffect(e9)
end
function c80000149.cbcon(e,tp,eg,ep,ev,re,r,rp)
	return r~=REASON_REPLACE
end
function c80000149.splimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2d0)
end
function c80000149.sccon(e)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0x2d0)
end
function c80000149.pcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return tc and tc:IsSetCard(0x2d0)
end
function c80000149.pfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x2d0)  and c:IsAbleToHand()
end
function c80000149.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80000149.pfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c80000149.pop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c80000149.pfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c80000149.cbfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2d0)
end
function c80000149.cbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80000149.cbfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c80000149.cbfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c80000149.cbfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c80000149.cbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeAttackTarget(tc)
	end
end
function c80000149.cecon(e,tp,eg,ep,ev,re,r,rp)
	if e==re or rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:GetCount()==1 and g:GetFirst()==e:GetHandler()
end
function c80000149.cefilter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return c:IsFaceup() and c:IsSetCard(0x2d0) and tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c80000149.cetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80000149.cefilter(chkc,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	if chk==0 then return Duel.IsExistingTarget(c80000149.cefilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c80000149.cefilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
end
function c80000149.ceop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end