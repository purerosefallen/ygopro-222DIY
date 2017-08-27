--★闇の魔法少女 えみる
function c114000749.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(114000749,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_LSCALE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c114000749.sccon)
	e2:SetValue(6)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(114000749,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c114000749.cost)
	e4:SetTarget(c114000749.target)
	e4:SetOperation(c114000749.spop)
	c:RegisterEffect(e4)
end
--activate condition
function c114000749.pfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcabb)
end
function c114000749.pfilter2(c)
	return c:IsSetCard(0xcabb)
end
--scale condition
function c114000749.sccon(e)
	local seq=e:GetHandler():GetSequence()
	if seq~=6 and seq~=7 then return false end
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	return not tc or not tc:IsSetCard(0xcabb)
end
--sp function
function c114000749.filter(c)
	return c:IsFaceup() and ( c:IsRace(RACE_SPELLCASTER) or c:IsAttribute(ATTRIBUTE_LIGHT) )
end
function c114000749.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(114000749)==0 end
	c:RegisterFlagEffect(114000749,RESET_CHAIN,0,1)
end
function c114000749.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c114000749.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c114000749.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c114000749.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114000749.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local q=tc:GetControler()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,1-q,false,false,POS_FACEUP)
	end
end