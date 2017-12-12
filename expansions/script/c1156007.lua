--门前的妖怪小姑娘
function c1156007.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_EARTH),2,2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c1156007.con1)
	e1:SetTarget(c1156007.tg1)
	e1:SetOperation(c1156007.op1)
	c:RegisterEffect(e1)
--  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,1156007)
	e2:SetCondition(aux.damcon1)
	e2:SetTarget(c1156007.tg2)
	e2:SetOperation(c1156007.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,1156007)
	e3:SetCondition(c1156007.con3)
	e3:SetTarget(c1156007.tg2)
	e3:SetOperation(c1156007.op2)
	c:RegisterEffect(e3)
--
end
--
function c1156007.con1(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and ep==tp
end
function c1156007.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(1156007)==0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c1156007.op1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(1156007,RESET_CHAIN,0,1)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--
function c1156007.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c1156007.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		local e2_1=Effect.CreateEffect(e:GetHandler())
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2_1:SetRange(LOCATION_MZONE)
		e2_1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		e2_1:SetValue(1)
		e:GetHandler():RegisterEffect(e2_1,true)
		local e2_2=Effect.CreateEffect(e:GetHandler())
		e2_2:SetType(EFFECT_TYPE_SINGLE)
		e2_2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2_2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2_2:SetReset(RESET_EVENT+0x1fe0000)
		e2_2:SetValue(LOCATION_REMOVED)
		e:GetHandler():RegisterEffect(e2_2,true)
	end
end
--
function c1156007.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end

