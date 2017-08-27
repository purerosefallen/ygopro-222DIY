--太古龙·绯红龙
function c10160004.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10160004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(EVENT_MSET)
	e2:SetCountLimit(1,10160004)
	e2:SetCost(c10160004.spcost)
	e2:SetTarget(c10160004.sptg)
	e2:SetOperation(c10160004.spop)
	c:RegisterEffect(e2)
	local e6=e2:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6) 
	local e7=e2:Clone()
	e7:SetCode(EVENT_CHANGE_POS)
	e7:SetCondition(c10160004.spcon)
	c:RegisterEffect(e7) 
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8) 
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10160004,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,10160004)
	e3:SetTarget(c10160004.actg)
	e3:SetOperation(c10160004.acop)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c10160004.antarget)
	c:RegisterEffect(e4)  
end

function c10160004.antarget(e,c)
	return c~=e:GetHandler()
end

function c10160004.acfilter(c,tp,ft)
	return aux.IsCodeListed(c,10160001) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp) and (bit.band(c:GetType(),0x80002)==0x80002 or (ft>0 and bit.band(c:GetType(),0x20002)==0x20002))
end

function c10160004.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10160004.acfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp,Duel.GetLocationCount(tp,LOCATION_SZONE)) end
end

function c10160004.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10160004,2))
	local tc=Duel.SelectMatchingCard(tp,c10160004.acfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp,Duel.GetLocationCount(tp,LOCATION_SZONE)):GetFirst()
	if tc and not tc:IsHasEffect(EFFECT_NECRO_VALLEY) then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc and tc:IsType(TYPE_FIELD) then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
	end
end

function c10160004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function c10160004.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end

function c10160004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c10160004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
