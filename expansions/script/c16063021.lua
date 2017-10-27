--zongjin
function c16063021.initial_effect(c)
	
	--cannot summon
	c:EnableUnsummonable()
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,16063021)
	e2:SetCondition(c16063021.spcon)
	e2:SetOperation(c16063021.spop)
	c:RegisterEffect(e2)
	--down fucking
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16063021,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,16063021)
	e3:SetTarget(c16063021.atdtg)
	e3:SetOperation(c16063021.atdop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCategory(CATEGORY_DEFCHANGE)
	c:RegisterEffect(e4)
end
function c16063021.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5c5)
end
function c16063021.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c)and Duel.IsExistingMatchingCard(c16063021.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c16063021.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c16063021.atdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c16063021.atdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if (tc:IsFaceup() or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(-400)
		tc:RegisterEffect(e1)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e3)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		
	end
end