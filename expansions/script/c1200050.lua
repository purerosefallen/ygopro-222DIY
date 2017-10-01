--LA SGA 希望的特普勒
function c1200050.initial_effect(c)
	c:SetUniqueOnField(1,0,1200050)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionCode,1200043),c1200050.ffilter,2,true)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c1200050.sprcon)
	e2:SetOperation(c1200050.sprop)
	c:RegisterEffect(e2)
	--fimbulvinter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200050,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(c1200050.con)
	e1:SetTarget(c1200050.tg)
	e1:SetOperation(c1200050.op)
	c:RegisterEffect(e1)
	--atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c1200050.adval)
	c:RegisterEffect(e6)
	--cannot announce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c1200050.antarget)
	c:RegisterEffect(e3)
end
function c1200050.ffilter(c)
	return (c:IsFusionCode(1200041) or c:IsFusionCode(1200042) or c:IsFusionCode(1200043) or c:IsFusionCode(1200050))
end
function c1200050.spfilter1(c,tp,ft)
	if c:IsFusionCode(1200043) and c:IsReleasable() and c:IsCanBeFusionMaterial(nil,true) and (c:IsControler(tp) or c:IsFaceup()) then
		if ft>0 or (c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)) then
			return Duel.IsExistingMatchingCard(c1200050.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,c,tp,nil)
		else
			return Duel.IsExistingMatchingCard(c1200050.spfilter3,tp,LOCATION_MZONE,0,1,c,tp,c)
		end
	else return false end
end
function c1200050.spfilter2(c,tp,rc)
	return c:IsCode(1200041,1200042,1200043,1200045) and c:IsReleasable() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup()) and c~=rc
end
function c1200050.spfilter3(c,tp,rc)
	return c:IsCode(1200041,1200042,1200043,1200045) and c:IsReleasable() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup()) and Duel.IsExistingMatchingCard(c1200050.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,c,tp,rc)
end
function c1200050.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c1200050.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,ft)
end
function c1200050.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.SelectMatchingCard(tp,c1200050.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,ft)
	local tc=g1:GetFirst()
	local g=Duel.GetMatchingGroup(c1200050.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,tc,tp,nil)
	local g2=nil
	if ft>0 or (tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)) then
		g2=g:Select(tp,2,2,nil)
	else
		g2=g:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
		local g3=g:Select(tp,1,1,g2:GetFirst())
			  g2:Merge(g3)
	end
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c1200050.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) 
end
function c1200050.spfilter4(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCode(1200011,1200012,1200013,1200014,1200015,1200016,1200041,1200042,1200043,1200050) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function c1200050.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(c1200050.spfilter4, tp, LOCATION_GRAVE, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, 0, 0)
end
function c1200050.op(e,tp,eg,ep,ev,re,r,rp)
	local ft = Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft < 1 then return end
	local g = Duel.GetMatchingGroup(c1200050.spfilter4, tp, LOCATION_GRAVE, 0, nil, e, tp)
	local count = g:GetCount()
	if count < 1 then return end
	local min = math.min(count, ft)
	local sg = Duel.SelectMatchingCard(tp, c1200050.spfilter4, tp, LOCATION_GRAVE, 0, min, ft, nil, e, tp)
	Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0, 1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c1200050.vfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfba) and c:IsFaceup() and not c:IsCode(1200050)
end
function c1200050.adval(e,c)
	local vg=Duel.GetMatchingGroup(c1200050.vfilter,tp,LOCATION_MZONE,0,nil)
	local sum=vg:GetSum(Card.GetAttack)
	return sum
end
function c1200050.antarget(e,c)
	return c~=e:GetHandler()
end