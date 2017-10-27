--七曜-金符『银龙』
function c2170705.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,2170705+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2170705,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c2170705.descon)
	e3:SetTarget(c2170705.destg)
	e3:SetOperation(c2170705.desop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c2170705.thtg)
	e4:SetOperation(c2170705.thop)
	c:RegisterEffect(e4)
end
function c2170705.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc,np=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_CONTROLER)
	return loc==LOCATION_SZONE and np==tp and re:IsActiveType(TYPE_SPELL) and rc:IsSetCard(0x211)
end
function c2170705.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c2170705.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c2170705.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,2170799,0x211,0x4011,2100,1500,6,RACE_DRAGON,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c2170705.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 then
		Duel.IsPlayerCanSpecialSummonMonster(tp,2170799,0,0x4011,2100,1500,6,RACE_DRAGON,ATTRIBUTE_LIGHT)
	end
	local token=Duel.CreateToken(tp,2170799)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end