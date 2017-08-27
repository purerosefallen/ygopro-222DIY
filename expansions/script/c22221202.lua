--白泽球船长的冒险
function c22221202.initial_effect(c)
	c:SetUniqueOnField(1,0,22221202)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(22221202,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CUSTOM+22221202)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return rp==tp
	end)
	e2:SetTarget(c22221202.stg)
	e2:SetOperation(c22221202.sop)
	c:RegisterEffect(e2)
	if c22221202.counter==nil then
		c22221202.counter=true
		c22221202[0]=4
		c22221202[1]=4
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_REMOVE)
		e3:SetCondition(c22221202.addcd)
		e3:SetOperation(c22221202.addcount)
		Duel.RegisterEffect(e3,0)
	end
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22221202,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c22221202.descon)
	e2:SetTarget(c22221202.destg)
	e2:SetOperation(c22221202.desop)
	c:RegisterEffect(e2)
end
c22221202.count_available=1
c22221202.named_with_Shirasawa_Tama=1
function c22221202.IsShirasawaTama(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Shirasawa_Tama
end
function c22221202.cfilter(c)
	return c22221202.IsShirasawaTama(c) and c:IsFaceup()
end
function c22221202.addcd(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22221202.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c22221202.f,rp,LOCATION_SZONE,0,1,nil)
end
function c22221202.f(c)
	return c.count_available==1 and c:IsFaceup()
end
function c22221202.addcount(e,tp,eg,ep,ev,re,r,rp)
	if c22221202[rp]<=1 then
		c22221202[rp]=4
		Duel.RaiseEvent(eg,EVENT_CUSTOM+22221202,re,r,rp,ep,ev)
	else c22221202[rp]=c22221202[rp]-1 end
end
function c22221202.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22221202.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c22221202.sfilter(c,e,tp)
	return c22221202.IsShirasawaTama(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c22221202.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsExistingMatchingCard(c22221202.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22221202.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
	end
end
function c22221202.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,0x40)==0x40
end

function c22221202.desfilter2(c)
	return c22221202.IsShirasawaTama(c) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end

function c22221202.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c22221202.desfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c22221202.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22221202.desfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


