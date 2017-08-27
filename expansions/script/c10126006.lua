--反骨神具 卡迦迪亚
function c10126006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10126006)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10126006.target)
	e1:SetOperation(c10126006.operation)
	c:RegisterEffect(e1)  
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c10126006.effcon)
	c:RegisterEffect(e2)  
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126006,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCountLimit(1,10126106)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c10126006.descon)
	e3:SetTarget(c10126006.destg)
	e3:SetOperation(c10126006.desop)
	c:RegisterEffect(e3)
	--equip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10126006,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,10126206)
	e4:SetTarget(c10126006.eqtg)
	e4:SetOperation(c10126006.eqop)
	c:RegisterEffect(e4)
end
function c10126006.eqfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c10126006.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10126006.eqfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c10126006.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	   local tc=Duel.SelectMatchingCard(tp,c10126006.eqfilter2,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	   if tc then
		  Duel.Equip(tp,c,tc)
	   end
end
function c10126006.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()
	return ec and tc and tc:IsFaceup() and tc:IsAttackBelow(ec:GetAttack())
end
function c10126006.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ec=c:GetEquipTarget()
	local bc=ec:GetBattleTarget()
	if bc:IsRelateToBattle() and Duel.Destroy(bc,REASON_EFFECT)~=0 and ec:IsRelateToBattle(e) and ec:IsFaceup() then
			 local e1=Effect.CreateEffect(c)
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			 e1:SetCode(EFFECT_EXTRA_ATTACK)
			 e1:SetValue(1)
			 e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			 ec:RegisterEffect(e1)
			 local e2=Effect.CreateEffect(c)
			 e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			 e2:SetCode(EVENT_ATTACK_ANNOUNCE)
			 e2:SetLabelObject(e1)
			 e2:SetOperation(aux.atrst)
			 e2:SetReset(RESET_PHASE+PHASE_BATTLE)
			 Duel.RegisterEffect(e2,tp)
	end
end
function c10126006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetEquipTarget():GetBattleTarget(),1,0,0)
end
function c10126006.effcon(e,c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c10126006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10126006.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c10126006.spfilter(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10126006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10126006.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   Duel.Equip(tp,c,g:GetFirst())
	end
end


