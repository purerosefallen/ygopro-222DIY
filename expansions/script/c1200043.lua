--LA SGA 節制的阿爾法
function c1200043.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c1200043.ffilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0xfba),true)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c1200043.aclimit)
	e3:SetCondition(c1200043.actcon)
	c:RegisterEffect(e3)
	--destroy
	local e2=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200043,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c1200043.descon)
	e2:SetTarget(c1200043.destg)
	e2:SetOperation(c1200043.desop)
	c:RegisterEffect(e2)
	--destroy
	local e2=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200043,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,1200043)
	e2:SetCost(c1200043.tgcost)
	e2:SetTarget(c1200043.tgtg)
	e2:SetOperation(c1200043.tgop)
	c:RegisterEffect(e2)
end
function c1200043.ffilter(c)
	return c:IsFusionSetCard(0xfba) and c:IsRace(RACE_MACHINE) and c:IsLevelAbove(5)
end
function c1200043.aclimit(e,re,tp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and not re:GetHandler():IsImmuneToEffect(e)
end
function c1200043.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	return a and a:IsSetCard(0xfba) and a:IsControler(tp)
end
function c1200043.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsSetCard(0xfba)
end
function c1200043.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,1,0,0)
end
function c1200043.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			Duel.Draw(tc:GetControler(),1,REASON_EFFECT)
		end
	end
end
function c1200043.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c1200043.tgfilter(c)
	return c:IsFusionSetCard(0xfba) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c1200043.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1200043.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end
function c1200043.spfilter(c,e,tp,atk,def)
	return c:IsFusionSetCard(0xfba) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and (c:GetAttack()==atk or c:GetDefense()==def)
end
function c1200043.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c1200043.tgfilter,tp,LOCATION_DECK,0,1,nil) then return false end
	local tg=Duel.SelectMatchingCard(tp,c1200043.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=tg:GetFirst()
	if tc then 
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(c1200043.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,atk,def) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(1200043,2)) then
				Duel.BreakEffect()
				local m=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local sg=Duel.SelectMatchingCard(tp,c1200043.spfilter,tp,LOCATION_GRAVE,0,1,2,nil,e,tp,atk,def)
				if sg:GetCount()>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end