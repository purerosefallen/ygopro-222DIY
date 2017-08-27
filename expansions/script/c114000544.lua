--★正義の魔法少女 美樹(みき)さやか
function c114000544.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114000544.spcon)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cost
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c114000544.dcon)
	e3:SetTarget(c114000544.dtg)
	e3:SetOperation(c114000544.dop)
	c:RegisterEffect(e3)
end
--sp summon
function c114000544.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcabb)
end
function c114000544.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c114000544.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end



function c114000544.dcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c114000544.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,0)
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	--Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c114000544.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(114000544,0)) then
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	else
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,114000545,0x223,0x4011,2100,2100,4,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP,1-tp) then
			local token=Duel.CreateToken(tp,114000545) --0x4011=TYPE_TOKEN(4000)+TYPE_NORMAL(10)+TYPE_MONSTER(1)
			Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
		end
	end
end